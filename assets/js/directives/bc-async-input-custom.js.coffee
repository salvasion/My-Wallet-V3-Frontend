walletApp.directive('bcAsyncInputCustom', (Wallet) ->
  {
    restrict: "E"
    require: 'ngModel'
    scope: {
      ngModel: '='
      validator: '='
      onSave: '='
      onChange: '='
      actionTitle: '='
      placeholder: '='
      type: '@'
      errorMessage: '='
    }
    transclude: true
    template: '<div ng-transclude></div>'
    link: (scope, elem, attrs, ngModel, transclude) ->
      scope.user = Wallet.user
      scope.status = 
        edit: false
        saving: false
        
      scope.form = 
        newValue: scope.ngModel
        
      if attrs.inline?
        scope.inline = true
        
      if scope.type?
        scope.type = "text"
        
      scope.edit = () ->
        # finds and focuses on the text input field
        # a brief timeout is necessary before trying to focus
        setTimeout (-> elem[0].children[1].children[0].focus()), 50
        scope.status.edit = 1
        
      scope.focus = () ->
        scope.status.edit = 1
        
      scope.validate = () ->
        if scope.form.newValue?
          if scope.validator?
            scope.validator(scope.form.newValue)
          else
            !scope.form.$error
        return true
        
      scope.save = () ->
        scope.status.saving = true
  
        success = () ->
          scope.status.saving = false
          scope.status.edit = false
    
        error = () ->
          scope.status.saving = false
    
        scope.onSave(scope.form.newValue, success, error)

      transclude(scope, (clone, scope) ->
        elem.empty().append(clone)
      )
    
  }
)
