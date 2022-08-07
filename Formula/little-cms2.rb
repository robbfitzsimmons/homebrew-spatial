class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.13/lcms2-2.13.1.tar.gz"
  sha256 "d473e796e7b27c5af01bd6d1552d42b45b43457e7182ce9903f38bb748203b88"
  license "MIT"
  version_scheme 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(/Little\s*CMS\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    root_url "https://github.com/robbfitzsimmons/homebrew-spatial/releases/download/little-cms2-2.13.1"
    sha256 cellar: :any,                 big_sur:      "ebfec4bde28cfae918f96c4b8e527931c72c52230b7931a26b33698ef396ab6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "554685796a79849ff6f05c8413ee653c7ac3fb8fdd43a85cbe767716879f9c35"
  end

  depends_on "jpeg-turbo"
  depends_on "robbfitzsimmons/spatial/libtiff"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
