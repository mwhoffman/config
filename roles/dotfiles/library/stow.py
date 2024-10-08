"""Simple implementation of a stow ansible module.

This is a modified version of https://github.com/caian-org/ansible-stow.
"""

import os
import re
from typing import Union

from ansible.module_utils.basic import AnsibleModule

# Define how to find conflicts based on stow's error message. This is version
# dependent, so we'll match the output of particular versions.
STOW_CONFLICT_RE = {
  "2.3.1": (
    r"^\* existing target is neither a link nor a directory: "
    r"(?P<target>.+)$"
  ),
  "2.4.0": (
    r"^\* cannot stow (?P<src>.+) over existing target (?P<target>.+) "
    r"since neither a link nor a directory and --adopt not specified$"
  )
}

# Copy the message for matching versions.
STOW_CONFLICT_RE["2.4.1"] = STOW_CONFLICT_RE["2.4.0"]


def has_stow(module: AnsibleModule) -> bool:
  """Return whether stow exists.

  Args:
    module: an AnsibleModule instance.

  Returns:
    bool indicating whether the stow binary exists.
  """
  rc, _, _ = module.run_command("which stow", check_rc=False)
  return rc == 0


def get_stow_version(module: AnsibleModule) -> Union[str, None]:
  """Get the installed stow version.

  Args:
    module: an AnsibleModule instance.

  Returns:
    A string representing the stow version or `None` if the version cannot be
    obtained.
  """
  rc, stdout, _ = module.run_command("stow --version")

  if rc != 0:
    return None

  match = re.match(
    r"^stow \(GNU Stow\) version (?P<version>\d+\.\d+\.\d+)$",
    stdout.strip())

  if not match:
    return None

  return match.group("version")


def get_conflicts_from_stderr(stderr: str, version: str) -> set[str]:
  """Parse the stderr returned by stow and find any conflicts.

  Args:
    stderr: the stderr (str) returned by running stow.
    version: the version of stow.

  Returns:
    A set of strings consisting of the conflicting files.
  """
  conflict_re = re.compile(STOW_CONFLICT_RE[version])
  conflicts = set()
  for line in stderr.split("\n"):
    match = conflict_re.match(line.strip())
    if match:
      conflicts.add(match.group("target"))
  return conflicts


def get_changes_from_stderr(stderr: str) -> tuple[set[str], set[str]]:
  """Return the set of unlinked and linked changes.

  Args:
    stderr: the stderr (str) returned by running stow.

  Returns:
    Two sets of strings the first of which are the set of files that have been
    removed by stow and the second is the set of files that have been added by
    stow.
  """
  # Each line should contain info for a single file that was linked/unlinked. So
  # we will grab that using the following regexes.
  unlinked_re = re.compile(r"^UNLINK: (?P<target>.+)$")
  linked_re = re.compile(r"^LINK: (?P<target>.+) =>")

  # Build up these two sets.
  unlinked = set()
  linked = set()

  for line in stderr.split("\n"):
    match = unlinked_re.match(line.strip())
    if match:
      unlinked.add(match.group("target"))
      continue
    match = linked_re.match(line.strip())
    if match:
      linked.add(match.group("target"))

  return unlinked-linked, linked-unlinked


def run_stow(
  module: AnsibleModule,
  version: str,
  stowdir: str,
  package: str,
  target: str,
) -> tuple[bool, str]:
  """Run the stow command."""
  # Construct the stow command.
  cmd = f"stow -v --no-folding -d {stowdir} -R {package} -t {target}"

  # In check mode add the -n option which should do nothing.
  if module.check_mode:
    cmd = f"{cmd} -n"

  # Run the command. If rc is nonzero there should be conflicts which we can
  # identify and mark as a failure.
  rc, _, stderr = module.run_command(cmd)
  if rc != 0:
    conflicts = get_conflicts_from_stderr(stderr, version)
    conflicts = ", ".join(conflicts)
    module.fail_json(msg=f"Conflicting targets: {conflicts}")

  # Otherwise we can find the links that were either removed or added. If any
  # were this counts as a change.
  unlinked, linked = get_changes_from_stderr(stderr)
  changed = bool(linked | unlinked)

  # Format the message.
  msg = ""
  for name, files in (("unlinked", unlinked), ("linked", linked)):
    if files:
      msg = msg + "; " if msg else ""
      msg = msg + f"{name}: " + ", ".join(files)

  return changed, msg


def main():
  """The module main routine."""

  module = AnsibleModule(
    argument_spec={
      "package": {"type": "str", "required": "True"},
    },
    supports_check_mode=True,
  )

  # Check that we can find stow.
  if not has_stow(module):
    module.fail_json(msg="unable to find stow")

  # First get the stow version and fail early if we can't.
  version = get_stow_version(module)
  if not version:
    module.fail_json(msg="unable to get stow version")

  # Fail if we don't know how to check the conflicts.
  if version not in STOW_CONFLICT_RE:
    module.fail_json(msg=f"unsupported stow version {version}")

  stowdir = "dotfiles"
  package = module.params["package"]  # pyright: ignore[reportArgumentType]
  target = os.environ.get("HOME")

  # This is mostly here to help with typing. The HOME environment variable
  # should always be set.
  if target is None:
    module.fail_json(msg="cannot evaluate the target ($HOME)")

  changed, msg = run_stow(module, version, stowdir, package, target)

  module.exit_json(changed=changed, msg=msg)


if __name__ == "__main__":
  main()
