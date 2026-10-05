# Filter home.package declarations by machine.
#
# Each entry: { hosts = "all" | [ "cleboost-sage" "cleboost-brain" ]; package = <derivation>; }
{
  pickForHost = hostName: items:
    builtins.map (item: item.package)
      (builtins.filter
        (item: item.hosts == "all" || builtins.elem hostName item.hosts)
        items);
}
