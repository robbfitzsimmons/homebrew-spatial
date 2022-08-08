class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.5.0.tar.gz"
  sha256 "0333806d6adecc6f7a91243b2b839ff4d2053823634d4f6ed7a59bc87409122a"
  license "BSD-2-Clause"
  head "https://github.com/uclouvain/openjpeg.git", branch: "master"

  bottle do
    root_url "https://github.com/robbfitzsimmons/homebrew-spatial/releases/download/openjpeg-2.5.0"
    sha256 cellar: :any,                 big_sur:      "74c23b74bb04c3af2d844f6ac785f0d8cb05a535d1fa310b138bb78dea07e6a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5a948e625c24b9494273be14d8f11320289107b40b16f630d38d348b59c0e26b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"
  depends_on "robbfitzsimmons/spatial/libtiff"
  depends_on "robbfitzsimmons/spatial/little-cms2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_DOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <openjpeg.h>

      int main () {
        opj_image_cmptparm_t cmptparm;
        const OPJ_COLOR_SPACE color_space = OPJ_CLRSPC_GRAY;

        opj_image_t *image;
        image = opj_image_create(1, &cmptparm, color_space);

        opj_image_destroy(image);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include.children.first}",
           testpath/"test.c", "-L#{lib}", "-lopenjp2", "-o", "test"
    system "./test"
  end
end
