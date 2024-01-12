let
  skull = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJUWjb81Mx3UJuoZKPL1N/Bx2BPjU5ONZ0+T5yFo4PY root@nixos";
  systems = [ skull ];

  skull-plzfgme = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBQJWEjX7YbQrB8EhK9PZhUNgBQbJzTQTmyz0JSI0gM plzfgme@gmail.com";
  lab-gyt = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOee8PRkLluCUJ19J8IWp2RTE2kQErRQzzeTw5mkEZhl plzfgme@mail.ustc.edu.cn";
  users = [ skull-plzfgme lab-gyt ];
in
{
  "config.dae".publicKeys = systems ++ users;
}
