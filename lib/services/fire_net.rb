class FireNet < ClusterManagement::Project
  tag 'app'
  
  project_options(
    requires: [
      :basic, :fs, :thin,      
      :rad_users, :rad_bag, :rad_saas
    ],
    name: '4ire.net',
    git: 'git@github.com:alexeypetrushin/4ire.net.git',
    skip_gems: true,
    skip_spec: true
  )
  
  def deploy
    update
    services.nginx.started    
    
    boxes do |box|
      logger.info "deploying :#{service_name} to #{box}"
    
      project = box[config.projects_path!].dir project_options[:name]
      runtime = project / :runtime
    
      logger.info "  configuring"
      config_src = "#{config.config_path}/services/fire_net/config".to_dir
      raise "no config for 4ire.net (#{production_config})!" unless config_src.exist?
      config_src.copy_to! runtime['config']
        
      logger.info "  symlinks"
      runtime['public/fs'].symlink_to! box[Services::Fs.data_path]
    
      logger.info "  restarting thin"

      services.thin.configure(runtime.path).restart
    end
    self
  end
end