users = User.create([{ username: 'Foo', password: "fooy", password_confirmation: "fooy", status: 'active' },
                     { username: 'bar', password: "fooy", password_confirmation: "fooy", status: 'disabled' }])
