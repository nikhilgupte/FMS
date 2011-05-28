module NestedFieldsHelper
		def add_nested_fields_for(form_builder, field, dom_id, *args)
			options = {
				:partial => field.to_s.singularize,
				:label => I18n.t('add_nested_fields.add') + ' ' + \
				          I18n.t(field, :scope => [:activerecord, :attributes, form_builder.object.class.to_s.underscore.downcase]).downcase,
        #:object => form_builder.object.class.reflect_on_association(field).klass.new
			}.merge(args.extract_options!)

			link_to_function("#{options[:label]}") do |page|
				form_builder.fields_for field, options[:object] , :child_index => 'NEW_RECORD' do |f|
				  html = render(:partial => options[:partial], :locals => { :form => f })
					page << "$('##{dom_id}').append('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()));"
					page << "#{options[:callback]}" if options[:callback]
				end
			end
		end

		def remove_nested_fields_for(form_builder, class_id, *args)
			options = {
				:label => I18n.t('add_nested_fields.remove'),
				:obj_name => I18n.t(form_builder.object.class.to_s.underscore.downcase, :scope => 'activerecord.models').downcase,
				:confirm => I18n.t('add_nested_fields.sure_delete'),
			}.merge(args.extract_options!)
			options[:confirm].sub!(/\{obj\}/, options[:obj_name]) unless options[:obj_name].nil?

			confirm = "if (confirm('#{options[:confirm]}'))"
			if form_builder.object.new_record?
				link_to_function(options[:label], :class => 'remove') do |page|
					page << "#{confirm} $(this).parents('.#{class_id}').remove()"
					page << "#{options[:callback]}" if options[:callback]
				end
			else
				form_builder.hidden_field( :_destroy, :value => "0") + link_to_function(options[:label], :class => 'remove') do |page|
					page << "#{confirm} $(this).parents('.#{class_id}').hide();$(this).prev().val(1)"
				end
			end
		end

end

