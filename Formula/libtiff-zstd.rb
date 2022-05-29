class LibtiffZstd < Formula
  desc "TIFF library and utilities with ZSTD codec enabled"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.3.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.3.0.tar.gz"
  sha256 "0e46e5acb087ce7d1ac53cf4f56a09b221537fc86dfc5daaad1c2e89e1b37ac8"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  # autoconf, automake, and libtool are needed for the patch.
  # Remove these dependencies when the patch is no longer needed.
  depends_on "autoconf@2.69" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"

  uses_from_macos "zlib"

  # Fix build on Monterey. Remove at next release.
  # Adapted from (to apply to the source tarball):
  # https://gitlab.com/libtiff/libtiff/-/commit/b25618f6fcaf5b39f0a5b6be3ab2fb288cf7a75b
  patch :DATA

  def install
    # This is needed to apply the patch. Remove when the patch is no longer needed.
    system "autoreconf", "--force", "--install", "--verbose"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
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

__END__
diff --git a/configure.ac b/configure.ac
index 9e419fba12e2773a915abe0861fe95c9569ce00f..9e9927925821327674df9cef70fa7cd82c8b1985 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1080,7 +1080,7 @@ dnl ---------------------------------------------------------------------------
 
 AC_SUBST(LIBDIR)
 
-AC_CONFIG_HEADERS([config.h libtiff/tif_config.h libtiff/tiffconf.h port/libport_config.h])
+AC_CONFIG_HEADERS([config/config.h libtiff/tif_config.h libtiff/tiffconf.h port/libport_config.h])
 
 AC_CONFIG_FILES([Makefile \
 		 build/Makefile \
@@ -1095,15 +1095,15 @@ AC_CONFIG_FILES([Makefile \
 		 contrib/stream/Makefile \
 		 contrib/tags/Makefile \
 		 contrib/win_dib/Makefile \
-                 html/Makefile \
+		 html/Makefile \
 		 html/images/Makefile \
 		 html/man/Makefile \
-                 libtiff-4.pc \
-                 libtiff/Makefile \
-                 man/Makefile \
+		 libtiff-4.pc \
+		 libtiff/Makefile \
+		 man/Makefile \
 		 port/Makefile \
 		 test/Makefile \
-                 tools/Makefile])
+		 tools/Makefile])
 AC_OUTPUT
 
 dnl ---------------------------------------------------------------------------
