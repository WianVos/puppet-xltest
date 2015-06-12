require 'spec_helper'

describe 'xltest' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      describe "xltest class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('xltest::params') }

        it { should contain_class('xltest::install').that_comes_before('xltest::config') }
        it { should contain_class('xltest::config') }
        it { should contain_class('xltest::service').that_subscribes_to('xltest::config') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'xltest class without any parameters on Solaris' do
      let(:facts) {{
        :osfamily => 'Solaris'
      }}

      it { expect { should }.to raise_error(Puppet::Error, /Solaris not supported/) }
    end
  end
end
