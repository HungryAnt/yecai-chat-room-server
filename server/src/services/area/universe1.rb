# coding: UTF-8

puts __FILE__

tiles_text = <<TILES
################################################################################################################################################################################################
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                       X                                                                      #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
#                                                                                                                                                                                              #
################################################################################################################################################################################################
################################################################################################################################################################################################
################################################################################################################################################################################################
TILES

create_area('universe1', 'universe1', tiles_text, :village)