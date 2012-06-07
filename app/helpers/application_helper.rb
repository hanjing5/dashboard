module ApplicationHelper
    def process(list)
        previous = 5
        list.each do |k, v|
            f = (v.to_f - previous.to_f) / previous.to_f
            list[k] = [v, previous, f]
            
            previous = v
        end
        return list
    end
end
