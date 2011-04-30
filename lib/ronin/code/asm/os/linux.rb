require 'ronin/asm/config'

module Ronin
  module Code
    module ASM
      module OS
        module Linux
          DATA_DIR = File.join('ronin','asm','linux')

          SYSCALLS = {
            :x86 => Ronin::ASM::Config.load_yaml_file(File.join(DATA_DIR,'x86','syscalls.yml')),
            :amd64 => Ronin::ASM::Config.load_yaml_file(File.join(DATA_DIR,'amd64','syscalls.yml'))
          }

          def syscall(name,*arguments)
            name = name.to_sym
            number = SYSCALLS[@arch][name]

            unless number
              raise(ArgumentError,"unknown syscall: #{name}")
            end

            if arguments.length > 6
              regs = @general_registers[1,1]

              critical_region(regs) do
                arguments.reverse_each { |arg| stack_push(arg) }

                reg_set stack_pointer, regs[0]
                reg_set number, @general_registers[0]
                super(number)
              end
            else
              regs = @general_registers[1,arguments.length]

              critical_region(regs) do
                arguments.reverse_each { |arg| reg_set(arg,regs.pop) }

                reg_set number, @general_registers[0]
                super(number)
              end
            end
          end
        end
      end
    end
  end
end
