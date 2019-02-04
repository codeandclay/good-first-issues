require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  test 'A language is returned when the user queries for part of its name' do
    language = Language.create(name: 'ruby')

    assert_equal 'ruby', Language.by_search_term('r').first.name
    assert_equal 'ruby', Language.by_search_term('ru').first.name
    assert_equal 'ruby', Language.by_search_term('rub').first.name
    assert_equal 'ruby', Language.by_search_term('uby').first.name
    assert_equal 'ruby', Language.by_search_term('by').first.name
    assert_equal 'ruby', Language.by_search_term('u').first.name
    assert_equal 'ruby', Language.by_search_term('b').first.name
    assert_equal 'ruby', Language.by_search_term('y').first.name
  end
end
