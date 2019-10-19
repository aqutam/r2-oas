# frozen_string_literal: true

# Referred to　lib/ruby/2.3.0/logger.rb
module R2OAS
  class StdoutLogger
    DEBUG = 0
    INFO = 1
    WARN = 2
    ERROR = 3
    FATAL = 4
    UNKNOWN = 5
    NULL = 6
    # Severity label for logging (max 5 chars).
    SEV_LABEL = %w[DEBUG INFO WARN ERROR FATAL NULL ANY].each(&:freeze).freeze

    # Logging severity threshold (e.g. <tt>Logger::INFO</tt>).
    attr_reader :level

    def initialize
      @progname = nil
      @level = INFO
      @default_formatter = Formatter.new
      @formatter = nil
    end

    # Set logging severity threshold.
    #
    # +severity+:: The Severity of the log message.
    def level=(severity)
      if severity.is_a?(Integer)
        @level = severity
      else
        _severity = severity.to_s.downcase
        case _severity
        when 'debug'
          @level = DEBUG
        when 'info'
          @level = INFO
        when 'warn'
          @level = WARN
        when 'error'
          @level = ERROR
        when 'fatal'
          @level = FATAL
        when 'unknown'
          @level = UNKNOWN
        when 'null'
          @level = NULL
        else
          raise ArgumentError, "invalid log level: #{severity}"
        end
      end
    end

    def debug(progname = nil)
      add(DEBUG, nil, progname)
    end

    def info(progname = nil)
      add(INFO, nil, progname)
    end

    def warn(progname = nil)
      add(WARN, nil, progname)
    end

    def error(progname = nil)
      add(ERROR, nil, progname)
    end

    def fatal(progname = nil)
      add(FATAL, nil, progname)
    end

    def unknown(progname = nil)
      add(UNKNOWN, nil, progname)
    end

    private

    def add(severity, _message = nil, progname = nil)
      severity ||= UNKNOWN
      return true if severity < @level

      puts format_message(format_severity(severity), Time.now, nil, progname)
    end

    def format_message(severity, datetime, progname, msg)
      (@formatter || @default_formatter).call(severity, datetime, progname, msg)
    end

    def format_severity(severity)
      SEV_LABEL[severity] || 'ANY'
    end

    # Default formatter for log messages.
    class Formatter
      Format = "%s, [%s#%d] %5s -- %s: %s\n"

      attr_accessor :datetime_format

      def initialize
        @datetime_format = nil
      end

      def call(severity, time, progname, msg)
        format(Format, severity[0..0], format_datetime(time), $PROCESS_ID.to_i, severity, progname, msg2str(msg))
      end

      private

      def format_datetime(time)
        time.strftime(@datetime_format || '%Y-%m-%dT%H:%M:%S.%6N ')
      end

      def msg2str(msg)
        case msg
        when ::String
          msg
        when ::Exception
          "#{msg.message} (#{msg.class})\n" <<
            (msg.backtrace || []).join("\n")
        else
          msg.inspect
        end
      end
    end
  end
end
