require 'json'
module Helper
  private

  # check the resource mapping in "_lm.resourceid". It can "system.gcp.resourcename" or "system.gcp.resourceid"
  def run_resourcemapping_case(emitted, expected)
    emit_log(emitted)
    wait = wait_for_output(500)
    if wait == false && expected != nil
      raise "Nothing has been written to the log file."
    elsif wait == false && expected == nil
      return
    end
    actual = fetch_output().pop
    actual = yield actual if block_given?
    assert_equal(expected["_lm.resourceId"].keys, actual["_lm.resourceId"].keys)
  end

  # check the message sent to lm. It can "textPayload" or "jsonPayload"
  def run_message_case(emitted, expected)
    emit_log(emitted)
    wait = wait_for_output(500)
    if wait == false && expected != nil
      raise "Nothing has been written to the log file."
    elsif wait == false && expected == nil
      return
    end
    actual = fetch_output().pop
    actual = yield actual if block_given?
    assert_equal(expected["message"], actual["message"])
    end

  # send logs to input plugin in fluentd.conf @type forward
  def emit_log(log)
    tag = if log.key?('tag') then log['tag'] else 'pubsub.publish.test' end
    formatted = JSON.generate(log)
    `echo '#{formatted}' | fluent-cat #{tag}`
  end

  def fetch_output()
    @outfile.readlines.map do |line|
        JSON.parse! line
    end
  end

  def wait_for_output(delay)
    i = 0
    imax = delay / 100
    while i < imax do
      return true unless outfile_empty?
      sleep 0.1
      i += 1
    end
    return false
  end

  def outfile_empty?()
    File.stat(@outpath).size == 0
  end
end
