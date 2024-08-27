{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  boost,
  capnproto,
  doxygen,
  flex,
  libdwarf-lite,
  pkg-config,
  python3,
  tbb_2021_11,
}:
stdenv.mkDerivation {
  pname = "naja";
  version = "0-unstable-2024-08-27";

  src = fetchFromGitHub {
    owner = "najaeda";
    repo = "naja";
    rev = "b687261ed2e3b273acd8fa25f078a0409ee30b26";
    hash = "sha256-f4jUAE3mSvdShtNgwKPMAEBQyT1PAaoFNnWwFCDjeD4=";
    fetchSubmodules = true;
  };

  outputs = [
    "dev"
    "lib"
    "out"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    bison
    capnproto
    cmake
    doxygen
    flex
    pkg-config
    python3
  ];

  buildInputs = [
    boost
    capnproto # cmake modules
    flex # include dir
    libdwarf-lite
    tbb_2021_11
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "CPPTRACE_USE_EXTERNAL_LIBDWARF" true)
      (lib.cmakeBool "CPPTRACE_USE_EXTERNAL_ZSTD" true)
    ]
    ++ lib.optionals stdenv.isDarwin [
      (lib.cmakeFeature "CMAKE_OSX_DEPLOYMENT_TARGET" "10.14")
    ];

  doCheck = true;

  meta = {
    description = "Structural Netlist API (and more) for EDA post synthesis flow development";
    homepage = "https://github.com/najaeda/naja";
    license = lib.licenses.asl20;
    maintainers = [
      # maintained by the team working on NGI-supported software, no group for this yet
    ];
    mainProgram = "naja_edit";
    platforms = lib.platforms.all;
  };
}
