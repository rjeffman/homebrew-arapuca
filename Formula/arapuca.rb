class Arapuca < Formula
  desc "Cross-platform process sandbox with kernel-enforced isolation"
  homepage "https://github.com/sergio-correia/arapuca"
  url "https://github.com/sergio-correia/arapuca/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "2dc0d2f972e47ac32d263eb43ff7203838fef3910fa13142019d01b2aba9c17b" # Will need to be filled after creating the release
  license "Apache-2.0"
  head "https://github.com/sergio-correia/arapuca.git", branch: "main"

  depends_on "rust" => :build
  depends_on "cbindgen" => :build

  def install
    # Build the project binaries
    system "cargo", "install", *std_cargo_args

    # Build the C library
    system "cargo", "build", "--release", "--lib"

    # Generate C header
    system "cbindgen", "--config", "cbindgen.toml",
           "--crate", "arapuca", "--output", "include/arapuca.h"

    # Install dynamic library
    if OS.mac?
      lib.install "target/release/libarapuca.dylib"
    elsif OS.linux?
      lib.install "target/release/libarapuca.so"
    end

    # Install static library
    lib.install "target/release/libarapuca.a"

    # Install header
    include.install "include/arapuca.h"

    # Generate and install pkg-config file
    (lib/"pkgconfig").mkpath
    pc_content = File.read("arapuca.pc.in")
      .gsub("@PREFIX@", prefix)
      .gsub("@LIBDIR@", lib)
      .gsub("@VERSION@", version)
      .gsub("@NATIVE_LIBS@", "-ldl -lpthread")
      .gsub("@INSTALL_FEATURES@", "")
    (lib/"pkgconfig/arapuca.pc").write pc_content
  end

  test do
    # Test the binary
    assert_match version.to_s, shell_output("#{bin}/arapuca --version 2>&1", 1)

    # Test basic sandbox execution
    output = shell_output("#{bin}/arapuca -- echo 'Hello from sandbox'")
    assert_match "Hello from sandbox", output

    # Test the C header is installed
    assert_predicate include/"arapuca.h", :exist?

    # Test the library is installed
    if OS.mac?
      assert_predicate lib/"libarapuca.dylib", :exist?
    elsif OS.linux?
      assert_predicate lib/"libarapuca.so", :exist?
    end
  end
end
