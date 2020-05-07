require "formula"

class Aliaser < Formula
	desc "An alias management / directory traversal tool for the command line"
	homepage "https://github.com/unforswearing/aliaser"
	url "https://github.com/unforswearing/aliaser/archive/1.5.0.tar.gz"
	sha256 "6d1b4d220a9e3d42938b9729377a40f6d759153d"

	def install
		bin.install "aliaser"
	end
end
