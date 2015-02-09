def s(cmd)
  # `sudo #{cmd}`
  `#{cmd}`
end

def mount(cmd, &block)
  # s "modprobe fuse"
  s "mkdir mnt"
  pid = fork do
    s cmd
  end
  block.call
  s "kill -9 #{pid}"
end

def t(cmd, &block)
  result = s cmd
  exit false unless `$?` == 0
  return unless block
  exit false unless block.call(result)
end

mount "./hello mnt" do
  t "ls mnt" do |result|
    result.len == 1
  end
  t "ls -a mnt" do |result|
    result.len == 3
  end
  t "cd mnt"
end
