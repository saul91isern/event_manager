#!/bin/sh

bin/event_manager eval 'Elixir.EventManager.Release.migrate()'
bin/event_manager start
