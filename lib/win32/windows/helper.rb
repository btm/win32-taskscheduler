require 'ffi'

module Windows
  module Helper
    extend FFI::Library

    ffi_lib :kernel32

    attach_function :FormatMessage, :FormatMessageA,
    [:uint32, :pointer, :uint32, :uint32, :pointer, :uint32, :pointer], :uint32

    FORMAT_MESSAGE_IGNORE_INSERTS    = 0x00000200
    FORMAT_MESSAGE_FROM_SYSTEM       = 0x00001000
    FORMAT_MESSAGE_MAX_WIDTH_MASK    = 0x000000FF

    def win_error(function, err=FFI.errno)
      error_msg = ''

      # specifying 0 will look for LANGID in the following order
      # 1.Language neutral
      # 2.Thread LANGID, based on the thread's locale value
      # 3.User default LANGID, based on the user's default locale value
      # 4.System default LANGID, based on the system default locale value
      # 5.US English
      dwLanguageId = 0

      flags = FORMAT_MESSAGE_FROM_SYSTEM |
              FORMAT_MESSAGE_IGNORE_INSERTS |
              FORMAT_MESSAGE_MAX_WIDTH_MASK
      FFI::MemoryPointer.new(:char, 1024) do |buf|

        msg_len = FormatMessage(flags, FFI::Pointer::NULL, err, dwLanguageId, buf, 1024, FFI::Pointer::NULL)

        error_msg = function + ': ' + buf.read_string(msg_len)
      end

      error_msg
    end

    def ole_error(function, err)
      regex = /OLE error code:(.*?)\sin/
      match = regex.match(err.to_s)

      if match
        error = match.captures.first.hex
        win_error(function, error)
      else
        "#{function}: #{err.to_s}"
      end
    end
  end
end
