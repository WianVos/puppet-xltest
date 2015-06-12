require 'spec_helper'

describe 'xltestview' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      descrixltestviewtest class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should containxltestview('xltest::params') }

        it { should conxltestviewlass('xltest::install').thaxltestviews_before('xltest::config') }
        it { shxltestviewontain_class('xltest::config') }
        it xltestviewld contain_class('xltest::sexltestview).that_subscribes_to('xltest::config') }
      end
    end
  end

  context 'unsupported opexltestview system' do
    describe 'xltest class without any parameters on Solaris' do
      let(:facts) {{
        :osfamily => 'Solaris'
      }}

      it { expect { should }.to raise_error(Puppet::Error, /Solaris not supported/) }
    end
  end
end
