class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.2.3.tar.gz"
  sha256 "f5d7ab2390b06b8a934a4fc35784291b3885b557780d099bd32f09241f9d83f9"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/robbfitzsimmons/homebrew-spatial/releases/download/webp-1.2.3"
    sha256 cellar: :any,                 big_sur:      "68bbbcc6c59cd0913243e37581fe1e21240f9758fac4644a59284303c2263e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7fadfcfbe589ab70b320c1c7a05e6e3d33267d0572a35044440233c8c486d4d8"
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "robbfitzsimmons/spatial/libtiff"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-gl",
                          "--enable-libwebpdecoder",
                          "--enable-libwebpdemux",
                          "--enable-libwebpmux"
    system "make", "install"
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
