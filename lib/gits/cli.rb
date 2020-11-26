module Gits
  class CLI

    VERSION_TEXT = "gits v#{Gits::VERSION} #{Gits::VERSION_TYPE}"
    def puts_version
      puts VERSION_TEXT
    end

    USAGE = <<~EOF
      usage: gits [--version] [--help] <command> [<args>]
    EOF

    def check_exit_args(argv)
      raise Error.new USAGE if argv.empty?
      case argv[0]
      when '--version'
        puts_version
        true
      else
        false
      end
    end

    def do_run(argv)
      return if check_exit_args(argv)
    end

    def run(argv)
      begin
        do_run(argv)
        return 0
      rescue Error => e
        STDERR.puts e.message
        return 1
      end
    end
  end
end
