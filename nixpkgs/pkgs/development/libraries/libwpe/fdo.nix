{ stdenv
, lib
, fetchurl
, meson
, pkg-config
, ninja
, wayland
, libepoxy
, glib
, libwpe
, libxkbcommon
, libGL
, libX11
, webkitgtk
 }:

stdenv.mkDerivation rec {
  pname = "wpebackend-fdo";
  version = "1.14.0";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/wpebackend-fdo-${version}.tar.xz";
    sha256 = "51sMsscUVEhBboaWAT2Ig/Z1xmwR7XUOBoZe/sWAkVU=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland
  ];

  buildInputs = [
    wayland
    libepoxy
    glib
    libwpe
    libxkbcommon
    libGL
    libX11
  ];

  meta = with lib; {
    description = "Freedesktop.org backend for WPE WebKit";
    license = licenses.bsd2;
    homepage = "https://wpewebkit.org";
    maintainers = webkitgtk.meta.maintainers ++ (with maintainers; [ matthewbauer ]);
    platforms = platforms.linux;
  };
}
