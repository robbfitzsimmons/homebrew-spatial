class Libtiff < Formula
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

  bottle do
    root_url "https://github.com/robbfitzsimmons/homebrew-spatial/releases/download/libtiff-4.4.0"
    sha256 cellar: :any,                 big_sur:      "4dd938d0dababadd08b728bc40037427ee0b0d4000eee6335d8a2fd00e3602a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "653a201460f5167ff6c604630beba09acced386e680c7e3ea8d6e8efe8c1e85b"
  end

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
