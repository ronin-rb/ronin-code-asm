require 'spec_helper'

require 'ronin/asm/archs/x86'
require 'ronin/asm/program'

describe Archs::X86 do
  subject { Program.new(:arch => :x86) }

  its(:general_registers) { should == [:eax, :ebx, :ecx, :edx, :esi, :edi] }

  its(:registers) { should have_key(:al)  }
  its(:registers) { should have_key(:ah)  }
  its(:registers) { should have_key(:ax)  }
  its(:registers) { should have_key(:eax) }

  its(:registers) { should have_key(:bl)  }
  its(:registers) { should have_key(:bh)  }
  its(:registers) { should have_key(:bx)  }
  its(:registers) { should have_key(:ebx) }

  its(:registers) { should have_key(:cl)  }
  its(:registers) { should have_key(:ch)  }
  its(:registers) { should have_key(:cx)  }
  its(:registers) { should have_key(:ecx) }

  its(:registers) { should have_key(:dl)  }
  its(:registers) { should have_key(:dh)  }
  its(:registers) { should have_key(:dx)  }
  its(:registers) { should have_key(:edx) }

  its(:registers) { should have_key(:sil) }
  its(:registers) { should have_key(:si)  }
  its(:registers) { should have_key(:esi) }

  its(:registers) { should have_key(:dil) }
  its(:registers) { should have_key(:di)  }
  its(:registers) { should have_key(:edi) }

  its(:registers) { should have_key(:bpl) }
  its(:registers) { should have_key(:bp)  }
  its(:registers) { should have_key(:ebp) }

  its(:registers) { should have_key(:spl) }
  its(:registers) { should have_key(:sp)  }
  its(:registers) { should have_key(:esp) }

  its(:registers) { should have_key(:cs) }
  its(:registers) { should have_key(:ds) }
  its(:registers) { should have_key(:es) }
  its(:registers) { should have_key(:fs) }
  its(:registers) { should have_key(:gs) }
  its(:registers) { should have_key(:ss) }

  its(:registers) { should have_key(:eip) }
end
