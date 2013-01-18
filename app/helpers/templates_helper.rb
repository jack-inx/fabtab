module TemplatesHelper
  def convert_time(time)
    "#{time.split('_')[0]} #{time.split('_')[1]}"
  end
  
  def rename_file(name)
    timeline = name.split('dump_')[1].split('.')[0]
    timeline = timeline.gsub('-','')
    timeline = timeline.gsub('_','')
    timeline = timeline.gsub(':','')
    return "Download_dump_"+timeline

  end
end
