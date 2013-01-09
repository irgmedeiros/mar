require 'mar'

# a decorator function *returns* a lambda.  methods aren't first-class in Ruby,
# so this is just how it's got to be.  On the other hand, it makes it very easy
# to accept options and use those in the method decorator!
def decorator(name)
  lambda { |arg, &blk|
    blk.call("MAR #{arg}! --from #{name}")
  }
end

class Foo
  _ decorator('foo')  # this gets passed in as an "option" to decorator()
  def foo(one_arg)  # this get called via blk.call, which manipulates one_arg before calling the original method
    one_arg + ', with love'
  end

  def bar  # this doesn't get changed at all, but let's make sure of that...
    'I get no respect, I tell ya\', no respect.'
  end
end

describe "Mar" do
  before do
    @foo = Foo.new
  end

  it 'should decorate Foo#foo' do
    @foo.foo('is great').should == 'MAR is great! --from foo, with love'
  end

  it 'should NOT decorate Foo#bar' do
    @foo.bar.should == 'I get no respect, I tell ya\', no respect.'
  end
end
