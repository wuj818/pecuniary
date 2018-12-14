RSpec.describe 'Session System' do
  it 'allows the admin to login and logout' do
    visit root_path

    expect(page).to have_no_link 'Logout'

    click_link 'Login'
    fill_in 'password', with: 'wrong'
    click_button 'Login'

    expect(page).to have_content(/incorrect password/i)
    expect(page).to have_no_link 'Logout'

    fill_in 'password', with: Rails.application.credentials.password[Rails.env.to_sym]
    click_button 'Login'

    expect(page).to have_content(/logged in/i)
    expect(page).to have_link 'Logout'
    expect(page).to have_no_link 'Login'
  end

  it 'redirects away from the login form if already logged in' do
    system_spec_login

    visit login_path

    expect(page).to have_content(/already logged in/i)
  end
end
