story_id_proc = Proc.new do |buffer|
  if buffer && buffer.name =~ %r{/.git/COMMIT_EDITMSG$}
    dir = File.dirname( File.dirname( File.expand_path( buffer.name ) ) )
    branch = Dir.chdir( dir ){ `git symbolic-ref HEAD 2>/dev/null`[ /[^\/\n]+$/ ] }
    if branch
      story_id = branch[ /^((?:us|de)\d{2,})-/i, 1 ].upcase
      if story_id
        if buffer.current_line !~ /\[#{story_id}\]/
          buffer.paste "[#{story_id}] "
        end
      end
    end
  end
end

$diakonos.register_proc( story_id_proc, :after_open )
