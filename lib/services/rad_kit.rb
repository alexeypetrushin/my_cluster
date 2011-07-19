class RadKit < ClusterManagement::Project
  tag :app
  
  project_options(
    requires: [
      :basic, :mail,
      :rad_core, :rad_common_interface, :mongoid_misc, :rad_saas
    ],
    name: 'rad_kit'
  )
end