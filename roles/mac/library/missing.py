"""Find missing packages."""

from ansible.module_utils.basic import AnsibleModule


def main():
  """The module main routine."""

  module = AnsibleModule(
    argument_spec={
      "packages": {"required": True, "type": "list"},
    },
    supports_check_mode=True,
  )

  packages = module.params["packages"]  # pyright: ignore[reportArgumentType]
  missing_packages = []

  # Try to find brew.
  for package, binary in packages:
    rc, _, _ = module.run_command(f"which {binary}")
    if rc != 0:
      missing_packages.append(package)

  # Return and update ansible facts.
  module.exit_json(missing_packages=missing_packages)


if __name__ == "__main__":
  main()
