class LibtiffZstd < Formula
  desc "TIFF library and utilities with ZSTD codec enabled"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.4.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.4.0.tar.gz"
  sha256 "917223b37538959aca3b790d2d73aa6e626b688e02dcda272aec24c2f498abed"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

<<<<<<< HEAD
=======
  bottle do
    root_url "https://github.com/robbfitzsimmons/homebrew-spatial/releases/download/libtiff-zstd-4.4.0"
    sha256 cellar: :any,                 big_sur:      "ba80b9495438174e636492f1dd2c66314302b3629af68326714a8cb8a0a2fdb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0d58d082272012230098e9c7b9c56fc5e2a70a3b9049b51f30304f6184ae698f"
  end

>>>>>>> 964971de5aa55b2916cafda38c4abe04f7882a7f
  depends_on "jbigkit"
  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-lzma
      --disable-webp
      --with-jbig-include-dir=#{Formula["jbigkit"].opt_include}
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end
