class CodeBuddy < Formula
  include Language::Python::Virtualenv

  desc "StickS3 companion for Codex on macOS"
  homepage "https://github.com/CharlexH/CodeBuddy"
  url "https://github.com/CharlexH/CodeBuddy/releases/download/v0.1.44/code-buddy-v0.1.44.tar.gz"
  sha256 "802e97a38de2c5dd0cc15006b8dfa60a6737c6c9d0671cd9de657369c0fbd6b0"
  license "MIT"

  depends_on "python@3.13"

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "code-buddy-helper" do
    url "https://github.com/CharlexH/CodeBuddy/releases/download/v0.1.44/code-buddy-macos-helper-v0.1.44.zip"
    sha256 "8335c5e280fe9eb9b06cf40fa4fd925b7bcc7ddfcec83268f0a273a9e9cf1ceb"
  end

  def install
    python = formula_opt_bin("python@3.13")/"python3.13"
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
