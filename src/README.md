# Wyvern
Full Wyvern source code

# Bugs
## Map Syntax Error
When trying to use any type signature with a map inside another map like this:
any<any<any>>
It will see^^ the two >> as a GreaterGreater Token and anymore vise versa
So for now please add spaces in between your <> like this:
any< any<any> >