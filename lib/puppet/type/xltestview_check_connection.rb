Puppet::Type.newtype(:xltestview_check_connection) do

  ensurable do
      defaultvalues
      defaultto :present
    end

  newparam(:name, :namevar => true ) do
    desc 'just a name'
  end

  newparam(:host) do
    desc 'the resolvable hostname of the server to be tested '
    defaultto 'localhost'
  end

  newparam(:port) do
    desc 'the resolvable hostname of the authentication server'

    defaultto 5516

    validate do |value|
      Integer(value)
    end

    munge do |value|
      Integer(value)
    end

  end

  newparam(:timeout) do
    defaultto 240

    validate do |value|
      # This will raise an error if the string is not an integer
      Integer(value)
    end

    munge do |value|
      Integer(value)
    end
  end
end