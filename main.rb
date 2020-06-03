require 'yaml'
require 'open3'

def get_env_variable(key)
	return (ENV[key] == nil || ENV[key] == "") ? nil : ENV[key]
end

ac_flutter_project_path = get_env_variable("AC_FLUTTER_PROJECT_PATH") || abort('Missing AC_FLUTTER_PROJECT_PATH.')
ac_flutter_build_mode = get_env_variable("AC_FLUTTER_BUILD_MODE") || abort('Missing AC_FLUTTER_BUILD_MODE.')
ac_flutter_build_extra_args = get_env_variable("AC_FLUTTER_BUILD_EXTRA_ARGS") || ""

def run_command(command)
    puts "@[command] #{command}"
    status = nil
    stdout_str = nil
    stderr_str = nil

    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        stdout.each_line do |line|
            puts line
        end
        stdout_str = stdout.read
        stderr_str = stderr.read
        status = wait_thr.value
    end

    unless status.success?
        puts stderr_str
        raise stderr_str
    end
    return stdout_str
end

run_command("cd #{ac_flutter_project_path} && flutter build ios #{ac_flutter_build_mode} #{ac_flutter_build_extra_args} ")

exit 0
