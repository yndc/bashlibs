#!/bin/bash
# args_example.sh   
# Example of args.sh usage
# Usage     : args_example.sh []
# Author    : Jonathan Steven (yondercode@gmail.com)
# License   : MIT

# In this example we'll create a simple command line script to order food from a virtual fast food restaurant.
# order.sh [FOOD_NAME] [QUANTITY] --pay-with cash
# The CLI should print the order back to the CLI user.
# So running "./order.sh burger 5 --pay-with cash" should print "Your order of 5 burgers will be made soon! You'll pay with cash"

# We'll also add optional parameters to add a drink with our order, --drink [DRINK_NAME], and optional flag 
# to add ketchup with our order with --with-ketchup

# "./order.sh burger 5 --with-ketchup --pay-with alipay --drink cola"
# Should print : "Your order of 5 burgers with ketchup and 5 colas will be made soon! You'll pay with alipay"

# First, let's define the positional arguments within SCRIPT_POSITIONAL_ARGS
# In our example, [FOOD_NAME] and [QUANTITY] is the positional arguments (their order matters) 
SCRIPT_POSITIONAL_ARGS=$'FOOD_NAME,The food that you want to order\n'
SCRIPT_POSITIONAL_ARGS=$SCRIPT_POSITIONAL_ARGS$'QUANTITY,Amount of the food that you want to order\n'

# Second, let's define the arguments within SCRIPT_NAMED_ARGS
# --pay-with is a required named parameter, so we need to declare "1" in the fourth data
SCRIPT_NAMED_ARGS=$'PARM,pw,pay-with,1,\\tPayment method of your order\n'

# --drink is an optional named parameter
SCRIPT_NAMED_ARGS=$SCRIPT_NAMED_ARGS$'PARM,d,drink,0,\\tYour drink\n'

# --with-ketchup is an optional flag 
SCRIPT_NAMED_ARGS=$SCRIPT_NAMED_ARGS$'FLAG,wk,with-ketchup,0,Use ketchup with your food\n'

# Now, source the args.sh
. ./args.sh

# Print the customer order
echo "Your order of ${QUANTITY} ${FOOD_NAME}s $([[ \"${WITH_KETCHUP}\" ]] && echo 'with ketchup')$([[ \"${DRINK}\" ]] && echo ' and' ${QUANTITY} ${DRINK}s) will be made soon! You'll pay with ${PAY_WITH}."