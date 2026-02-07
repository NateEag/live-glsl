{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake

    # Wayland-related packages
    wayland
    libGL
    # Is this redundant with libGL?
    egl-wayland
    libxkbcommon
    wayland-scanner
    wayland-protocols
    glfw-wayland
    libffi

    # X11-related packages.
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi

    # Apparently doing this in nativeBuildInputs auto-populates the
    # pkg-config-related env vars.
    pkg-config
  ];

  # FIXME: Is setting LD_LIBRARY_PATH explicitly really the right approach?
  #
  # Since the library's loaded dynamically, it might be, but need to research that.
  shellHook = ''export LD_LIBRARY_PATH="${
    pkgs.lib.makeLibraryPath [
      pkgs.wayland
      pkgs.libxkbcommon
      pkgs.egl-wayland
      pkgs.libGL
    ]
  }:$LD_LIBRARY_PATH" '';
}
