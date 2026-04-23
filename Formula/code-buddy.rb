class CodeBuddy < Formula
  include Language::Python::Virtualenv

  desc "StickS3 Bluetooth approvals for Codex CLI on macOS"
  homepage "https://github.com/CharlexH/CodeBuddy"
  url "https://github.com/CharlexH/CodeBuddy/releases/download/v0.1.2/code-buddy-v0.1.2.tar.gz"
  sha256 "9eeb13de43a8a16ec240d91c160ca6b0cdb37bf593a9538b917f7d0ade852e3d"
  license "MIT"

  depends_on "python@3.13"

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "code-buddy-helper" do
    url "https://github.com/CharlexH/CodeBuddy/releases/download/v0.1.2/code-buddy-macos-helper-v0.1.2.zip"
    sha256 "9250d0649b75bde77f5ea453c158ce86c57517cbe44bca9ea228b3fcd6b8a11b"
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
