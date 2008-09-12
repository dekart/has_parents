require File.join(File.dirname(__FILE__), "lib", "action_controller", "has_parents")

ActionController::Base.send(:include, ActionController::HasParents)