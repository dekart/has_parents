require File.join(File.dirname(__FILE__), "action_controller", "has_parents")

ActionController::Base.send(:include, ActionController::HasParents)