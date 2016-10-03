# GemFresh

[![Code Climate](https://codeclimate.com/github/dmcouncil/gem_fresh/badges/gpa.svg)](https://codeclimate.com/github/dmcouncil/gem_fresh)

The purpose of GemFresh is to expose useful information about how outdated your application gems are.

## Setup

Create `config/initializers/gem_fresh.rb` for your Rails application.  Fill it out like this:

    # Any gems that you put in the Gemfile should also be listed here.
    # The rake metrics:outdated_gems task calculates which gems are
    # outdated and then combines that information with the information
    # listed here about a particular gem's reach in the application code.
    #
    GemFresh::Config.configure do |gems|

      # Updating these gems could require you to make large, system-wide changes
      # to the application code.
      gems.with_system_wide_impact %w(
        resque
        rspec
        ...
      )

      # Updating these gems could require you to make some changes to small
      # sections of the application.
      gems.with_local_impact %w(
        fog
        tabulous
        ...
      )

      # When updating these gems, you barely have to touch any code at all.
      gems.with_minimal_impact %w(
        airbrake
        bullet
        ...
      )

      # We ignore these since we are in complete control of their update cycles.
      gems.that_are_private %w(
        job_state
        ...
      )

    end

## Usage

See information on your outdated gems by running the rake task:

    rake gem_fresh

This combines information from `bundle outdated` with the information in the GemFresh config to give a weighted view as to how outdated your third-party Ruby code is and how much it matters.

Whenever you add a gem to your Gemfile, add it to GemFresh.rb so that the rake task knows how important the gem is.

Gems are assigned points.  The more central a gem is, and the more outdated it is, the higher the points.  You can think of the points as a "bounty" on the gem, telling you how badly it needs to be updated.

## About

GemFresh was originally developed at [the District Management Council](http://dmcouncil.org) by Wyatt Greene, and is now maintained by [DMC](/dmcouncil).
