let
  skull = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJUWjb81Mx3UJuoZKPL1N/Bx2BPjU5ONZ0+T5yFo4PY root@nixos";
  dragon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0rA1Urff5PJhYQRUmFtm/ZkoqxZXJvRjfbK5L0QN+T root@nixos";
  systems = [ skull dragon ];

  skull-plzfgme = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBQJWEjX7YbQrB8EhK9PZhUNgBQbJzTQTmyz0JSI0gM plzfgme@gmail.com";
  lab-gyt = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOee8PRkLluCUJ19J8IWp2RTE2kQErRQzzeTw5mkEZhl plzfgme@mail.ustc.edu.cn";
  dragon-plzfgme = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINz3/+eN+BPnXPHJUMGrAj/qvToyPXVO0PFs7hIIGfLz plzfgme@gmail.com";
  users = [ skull-plzfgme lab-gyt dragon-plzfgme ];
in
{
  "config.dae".publicKeys = systems ++ users;
}
