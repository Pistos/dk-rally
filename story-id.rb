card_id_proc = Proc.new do |buffer|
  if buffer && buffer.name =~ %r{/.git/COMMIT_EDITMSG$}
    dir = File.dirname( File.dirname( File.expand_path( buffer.name ) ) )
    branch = Dir.chdir( dir ){ `git symbolic-ref HEAD 2>/dev/null`[ /[^\/\n]+$/ ] }
    if branch
      card_id = branch[ /^TR-([A-Za-z0-9]{8,})-/i, 1 ]
      if card_id && buffer.current_line !~ /\[#{card_id}\]/
        buffer.paste "[#{card_id}] "
      end
    end
  end
end

$diakonos.register_proc( card_id_proc, :after_open )
