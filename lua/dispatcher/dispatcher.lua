
--[[subscription_tree
The subscription tree represents the subscriptions to a topic and its subtopics.
It will be a table with keys and values interpreted in the following manner:
  key -> number : value -> subscribe_callback
  key -> string : value -> subscription_tree
]]
--[[subscribe_callback
The subscription_callback will be called when the handler recieves an event in a topic it is subscribed to.
It is a function with the type function(dispatcher: dispatcher, topic: string, payload: string) -> (die: bool | replace: subscribe_callback)
]]
--[[topic and subscription format
A topic consists of a series of subtopics separated by "/".
Leading, trailing, and duplicated "/"'s are ignored, so the topics
  "a/b"
  "/a/b/"
  "a//b/"
are considered equivalent.

A subtopic can be either a string that does not contain "/" or a wildcard.

There are two wildcards accepted by the event dispatch system: "#" and "+"
The "+" wildcard is used to match a single level of the hierarchy.
A subscription to "a/+" will match
  "a/b"
  "a/c"
  "a/d"
but will not match
  "a/b/c"
A subscription to "a/+/c" will match
  "a/b/c"
  "a/d/c"
  "a/e/c"
but will not match
  "a/b/d/c"
The "#" wildcard is used to match all remaining levels of the topic hierarchy.
A subscription to "a/#" will match
  "a/b"
  "a/c"
  "a/b/c"
  "a/b/c/d"
A "#" wildcard may only be used as the last subtopic.
]]
--[[notification behavior
The subscription tree is navigated from the root and "#" wildcard callbacks are invoked immediately when encountered.
This means that if a "#" wildcard callback adds a subscription deeper in the hierarchy, the newly added callback will also recieve the event.
However, there is no prescribed ordering on subscriptions which are specified without "#" wildcards.
Any handlers added by a callback from a subscription without "#" wildcards will not be invoked to handle this event.
]]

local dispatcher = {}

local topic_pattern = "[^%/]+"
function dispatcher.subscribe(self, topic, callback)
  local subtable = self.subscriptions
  for top in string.gmatch(topic, topic_pattern) do
    if not subtable[top] then
      subtable[top] = {}
    end
    subtable = subtable[top]
  end
  table.insert(subtable, callback)
end

function dispatcher.dispatch_callbacks(self, handlertab, topic, payload)
  local nHandlers = #handlertab
  local j = 1
  while j <= nHandlers do
    local result = handlertab[j](self, topic, payload)
    if result then
      if type(result) == "function" then
        handlertab[j] = result
      else
        table.remove(handlertab, j)
        nHandlers = nHandlers-1
        j = j - 1
      end
    end
    j = j + 1
  end
end

function dispatcher.notify(self, topic, payload)
  local subtables = {self.subscriptions}
  local nTabs = 1
  for top in string.gmatch(topic, topic_pattern) do
    local i = 1
    while i <= nTabs do
      if subtables[i]["#"] then
        self:dispatch_callbacks(subtables[i]["#"], topic, payload)
      end
      if subtables[i][top] then
        if subtables[i]["+"] then
          table.insert(subtables, subtables[i]["+"])
          nTabs = nTabs + 1
        end
        subtables[i] = subtables[i][top]
      elseif subtables[i]["+"] then
        subtables[i] = subtables[i]["+"]
      else
        table.remove(subtables, i)
        nTabs = nTabs - 1
        i = i - 1
      end
      i = i+1
    end
  end
  for i=1,nTabs do
    self:dispatch_callbacks(subtables[i], topic, payload)
  end
end

function dispatcher.create()
  return {
    subscriptions = {},
    subscribe = dispatcher.subscribe,
    notify = dispatcher.notify,
    dispatch_callbacks = dispatcher.dispatch_callbacks
  }
end

return dispatcher