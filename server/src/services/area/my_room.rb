# coding: UTF-8

puts __FILE__

tiles_text = <<TILES
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
#####################    #######################################################
########    #########    #######################################################
########                            ############################################
#######                             ############################    ############
#######                             ##########################         #########
#######                             #########################           ########
#######                               ###################        X      ########
#######                               ################                   #######
#######                                #############                     #######
#######                                 ###########                      #######
#######                                  ########                        #######
######                                    ######                         #######
######                                     ###                           #######
#######                                                                  #######
#########                                                                #######
#########                                                                #######
#########                                                                #######
#########                                                                #######
#########                                                                 ######
#########                                                                 ######
#########                                                                 ######
#########                                                                 ######
#########                                                                 ######
#########                                                                 ######
#########                                                                 ######
#########                                                                 ######
#########                                                                 ######
#########                                                                   ####
#########                                                                   ####
########                                                                       #
######                                                                         #
###                                                                            #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
##                                                                             #
################################################################################
################################################################################
################################################################################
TILES

create_area('my_room', 'my_room', tiles_text, :village)