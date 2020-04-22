class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https://github.com/MichaelMure/git-bug"
  url "https://github.com/MichaelMure/git-bug/archive/0.7.1.tar.gz"
  sha256 "78a6c7dee159cdad4ad69066d6d8fc4b7c259d5ea6351aaf6709b6ac03ff3d2f"

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "git-bug"
  end

  test do
    # Version
    assert_includes shell_output("#{bin}/git-bug --version"), "git-bug version"
    # Version through git
    assert_includes shell_output("git bug --version"), "git-bug version"

    output = ""
    mkdir testpath/"git-repo" do
      system "git", "init"
      system "git", "config", "user.name", "homebrew"
      system "git", "config", "user.email", "a@a.com"
      system "yes \"a b http://www/www\" '' | git bug user create"
      system "git", "bug", "add", "-t", "\"Issue 1\"", "-m", "\"Issue body\""
      system "git", "bug", "add", "-t", "\"Issue 2\"", "-m", "\"Issue body\""
      system "git", "bug", "add", "-t", "\"Issue 3\"", "-m", "\"Issue body\""
      output = shell_output("git bug ls")
    end

    assert_includes output, "Issue 2"
  end
end
