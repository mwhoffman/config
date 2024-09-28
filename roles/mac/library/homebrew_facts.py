"""Fact module for homebrew."""

from ansible.module_utils.basic import AnsibleModule


def main():
  """The module main routine."""

  module = AnsibleModule(
    argument_spec={},
    supports_check_mode=True,
  )

  # Try to find brew.
  rc, _, _ = module.run_command("which brew")
  if rc != 0:
    module.fail_json(msg="unable to find brew")

  # Try to get the brew prefix.
  rc, stdout, _ = module.run_command("brew --prefix")
  if rc != 0:
    module.fail_json(msg="unable to determine brew prefix")

  # Assemble homebrew facts.
  homebrew_facts = {
    "prefix": stdout.strip(),
  }

  # Return and update ansible facts.
  module.exit_json(ansible_facts={"homebrew": homebrew_facts})


if __name__ == "__main__":
  main()
