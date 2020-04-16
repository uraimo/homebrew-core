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
    # List issues outside a repository
    assert_includes shell_output("git bug ls 2>&1", 1), "Error: git-bug must be run from within a git repo"
    # Add issue outside a repository
    assert_includes shell_output("git bug add 2>&1", 1), "Error: git-bug must be run from within a git repo"
    # Push issues to a remote from outside a repository
    assert_includes shell_output("git bug push origin 2>&1", 1), "Error: git-bug must be run from within a git repo"
    # Pull issues from a remote from outside a repository
    assert_includes shell_output("git bug pull origin 2>&1", 1), "Error: git-bug must be run from within a git repo"
    
    mkdir testpath/"git-repo" do
      output = shell_output("git init")
      output = shell_output("git config user.name homebrew;git config user.email a@a.com")
      output = shell_output("yes \"a b http://www/www\" | git bug user create")
      output = shell_output("git bug add -t \"Issue 1\" -m \"Issue body\"")
      output = shell_output("git bug add -t \"Issue 2\" -m \"Issue body\"")
      output = shell_output("git bug add -t \"Issue 3\" -m \"Issue body\"")
      assert_includes "Issue 2", shell_output("git", "bug", "ls")
    end
  end
end
