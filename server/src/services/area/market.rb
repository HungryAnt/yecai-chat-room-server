# coding: UTF-8

puts __FILE__

market1_tiles_text = <<TILES
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
#########################################                                      #
#####################AAAAA####                                                 #
#####################AAAAA                                                     #
#####################AAAAA                                                     #
#####################AAAAA                                                     #
#####################AAAAA                      ################################
#####################AAAAA                  ####################################
####################      B             ########################################
###################                 ########################      ##############
#######                              ######################                  ###
#                                      ###############                         #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                           X  #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
###                                                                            #
#########                                                                      #
############                                                                   #
###############                                                                #
###############                                                                #
##################                                                             #
###################                                                            #
####################                                                           #
#####################                                                          #
######################                                                         #
################################################################################
################################################################################
################################################################################
TILES

create_area('market1', 'market', market1_tiles_text, :village)

market2_tiles_text = <<TILES
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
#####################################################################    #######
##################################      ######CCCCCCCCCCCCCCCC#######    #######
#################################        #####CCCCCCCCCCCCCCCC#######    #######
#################################        #####CCCCCCCCCCCCCCCC#######    #######
#################################        #####CCCCCCCCCCCCCCCC#######    #######
#################################        #####CCCCCCCCCCCCCCCC#######    #######
#################################        #####CCCCCCCCCCCCCCCC#######    #######
#################################        #####CCCCCCCCCCCCCCCC#######    #######
BBBB                                          CCCCCCCCCCCCCCCC                ##
BBBB                                                                          ##
BBBB                                                 D                        ##
BBBB                                                                          ##
BBBB                                                                          ##
BBBB                                                                          ##
BBBB                                                                          ##
BBBB A                                                                        ##
BBBB                                                                          ##
BBBB                                                                          ##
BBBB                                                                          ##
BBBB                                                                          ##
BBBB                                                                          ##
BBBB                                                                          ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
####                                                                        ####
######                                                                    ######
########                                                                ########
################################################################################
################################################################################
################################################################################
TILES

create_area('market2', 'market', market2_tiles_text, :village)

market3_tiles_text = <<TILES
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
#######################################################################DDDDDDDD#
#######################################################################DDDDDDDD#
#######################################################################DDDDDDDD#
#######################################################################DDDDDDDD#
######################################################################         #
#####################################################################     C    #
####################################################################           #
###################################################################            #
#################################################################              #
################################################################               #
##############################################################                 #
#############   #   #########################################                  #
#############   #   ########################################                   #
#############   #   ########################################                   #
#############   #   #######################################                    #
######      #   #   ######################################                   ###
##                  #####################################                   ####
#                          ###########       ###########                  ######
#                                                                        #######
#                                                                        #######
#                                                                      #########
#                                                                     ##########
#                                                                    ###########
#                                                                    ###########
#                                                                   ############
#                                                                   ############
#                                                                   ############
#                                                                   ############
#                                                                         ######
#                                                                         ######
#                                                                         ######
#                                                                         ######
#                                                                         ######
#                                                                         ######
#                                                                         ######
#                                                                    ###########
#                                                                   ############
#                                                                   ############
#                                                                   ############
#                                                                    ###########
#                                                                         ######
#                                                                         ######
###                                                                       ######
####                                                                      ######
#####                                                                     ######
########                                                            ############
###########                                                       ##############
############                                                      ##############
##############                                              ####################
##############                                             #####################
###############                                           ######################
#################                                        #######################
##################                                      ########################
###################                                     ########################
################################################################################
TILES

create_area('market3', 'market', market3_tiles_text, :village)