require 'spec_helper'

describe 'mymodule' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('mymodule::install') }
        it { is_expected.to contain_class('mymodule::config') }
        it { is_expected.to contain_class('mymodule::service') }
        it { is_expected.to contain_package('mymodule').with_ensure('present') }
        it { is_expected.to contain_service('mymodule').with_ensure('running').with_enable(true) }
      end

      context 'with custom parameters' do
        let(:params) do
          {
            package_ensure: 'latest',
            service_ensure: 'stopped',
            service_enable: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('mymodule').with_ensure('latest') }
        it { is_expected.to contain_service('mymodule').with_ensure('stopped').with_enable(false) }
      end
    end
  end
end
