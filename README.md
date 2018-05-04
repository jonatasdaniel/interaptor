# Interaptor

[![Build Status](https://travis-ci.org/jonatasdaniel/interaptor.svg?branch=master)](https://travis-ci.org/jonatasdaniel/interaptor)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'interaptor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interaptor

## Why?

Interactor is a single purpose object used to encapsulate business logic of the application. Inspired by [collectiveidea/**interactor**](https://github.com/collectiveidea/interactor).

The reason of create another Interactor Ruby gem is because I would like to have object that I could instantiate and pass parameters like a PORO object. I'm not a big fan of calling my business objects using class methods.

## Usage

- create your interactor class

```ruby
class CreateBankAccount
  include Interaptor

  def initialize(current_user)
    @current_user = current_user
  end

  def execute(name:, account_number:, routing_number:)
    # do something
    bank_account = BankAccount.create!(
      name: name, account_number: account_number, routing_number: routing_number
    )

    return bank_account
  end
end
```

and `call` it

```ruby
result = CreateBankAccount.new(my_logged_user).call(**bank_account_params)
if result.success?
  result.value # value is the object returned in your interactor, in this case, bank_account
else
  result.errors.each do |error|
    puts "Some error happened related to #{error.source}. Detail: #{error.message}"
  end
end

```

or you can `call!` expecting an exception if some error happens
```ruby
begin
  bank_account = CreateBankAccount.new(my_logged_user).call!(**bank_account_params)
rescue Interaptor::Failure => e
  e.errors.each do |error|
    puts "Some error happened related to #{error.source}. Detail: #{error.message}"
  end
end
```

To add errors inside your interactor class you have three ways:
- add error and keep with your interactor processing (keep in mind that this option will not raise an exception when calling `call!` method)
```ruby
class CreateBankAccount
  include Interaptor

  def execute
    add_error('Some error', source: 'some optional source')

    #do something
  end

end
```

- add error and stop processing
```ruby
class CreateBankAccount
  include Interaptor

  def execute
    fail!('Some error', source: 'some optional source')

    #nothing more will be executed here
  end

end
```

- add multiple errors and stop processing
```ruby
class CreateBankAccount
  include Interaptor

  def execute
    add_error('Some error', source: 'some optional source')
    add_error('Some error again', source: 'some optional source')
    fail!

    #nothing more will be executed here
  end

end
```

You also have the option to add before/after callbacks like:
```ruby
class CreateBankAccount
  include Interaptor

  before do
    # execute something before execute method
  end

  after do
    # execute something after execute method if no exception is thrown 
  end

  def execute
    #something here
  end

end
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jonatasdaniel/interaptor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Interaptor project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jonatasdaniel/interaptor/blob/master/CODE_OF_CONDUCT.md).
