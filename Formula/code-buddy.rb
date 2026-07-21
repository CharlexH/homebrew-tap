class CodeBuddy < Formula
  include Language::Python::Virtualenv

  desc "StickS3 companion for Codex on macOS"
  homepage "https://github.com/CharlexH/CodeBuddy"
  url "https://github.com/CharlexH/CodeBuddy/releases/download/v0.1.32/code-buddy-v0.1.32.tar.gz"
  sha256 "82e1d4cdbcfceba5a67975776d8ad718973a35101d2f1bede655e89fb41aff99"
  license "MIT"

  depends_on "python@3.13"

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "code-buddy-helper" do
    url "https://github.com/CharlexH/CodeBuddy/releases/download/v0.1.32/code-buddy-macos-helper-v0.1.32.zip"
    sha256 "ecacf3787dbb99d985fb65ae3cd6479f9ce838bbdc517d2a4fe68e15032633cc"
  end

  def install
    python = Formula["python@3.13"].opt_bin/"python3.13"
    venv = virtualenv_create(libexec, python)
    venv.pip_install resource("websockets")
    venv.pip_install buildpath

    helper_dest = libexec/"helper"
    helper_dest.mkpath
    helper_resource = resource("code-buddy-helper")
    helper_resource.fetch
    system "ditto", "-x", "-k", helper_resource.cached_download, helper_dest

    (bin/"code-buddy").write_env_script libexec/"bin/code-buddy",
      CODEX_BUDDY_BLE_BACKEND:    "native",
      CODEX_BUDDY_BLE_HELPER_APP: helper_dest/"CodeBuddyBLEHelper.app"
  end

  test do
    assert_match "doctor", shell_output("#{bin}/code-buddy --help")
  end
end
